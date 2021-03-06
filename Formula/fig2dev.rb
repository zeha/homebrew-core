class Fig2dev < Formula
  desc "Translates figures generated by xfig to other formats"
  homepage "https://mcj.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mcj/fig2dev-3.2.7b.tar.xz"
  sha256 "47dc1b4420a1bc503b3771993e19cdaf75120d38be6548709f7d84f7b07d68b2"

  livecheck do
    url :stable
    regex(%r{url=.*?/fig2dev[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  bottle do
    sha256 "6d52c679f208194d6128a64fd9b14db2dd49a2ff1600e925500feb8e248cb0b5" => :big_sur
    sha256 "19a51590db79ab018f309a3d5a2c2390b5c670fc54145a5256d6b26533377b0e" => :arm64_big_sur
    sha256 "0ffe4d06ce3f489b724facdae111d0358ac5a902733f5c2ccedab8f4f3759893" => :catalina
    sha256 "f640a65192bbae6f8801e6f07d57ff8d24ffda78ea471dacaa1b33684a7858ae" => :mojave
    sha256 "1020f0333374fbfcb88d3bf2b2ca89b40c83f7863968f4d28dad1654ff9905df" => :high_sierra
  end

  depends_on "ghostscript"
  depends_on "libpng"
  depends_on "netpbm"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-transfig
      --without-xpm
      --without-x
    ]

    system "./configure", *args
    system "make", "install"

    # Install a fig file for testing
    pkgshare.install "fig2dev/tests/data/patterns.fig"
  end

  test do
    system "#{bin}/fig2dev", "-L", "png", "#{pkgshare}/patterns.fig", "patterns.png"
    assert_predicate testpath/"patterns.png", :exist?, "Failed to create PNG"
  end
end
