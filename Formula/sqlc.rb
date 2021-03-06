class Sqlc < Formula
  desc "Generate type safe Go from SQL"
  homepage "https://sqlc.dev/"
  url "https://github.com/kyleconroy/sqlc/archive/v1.6.0.tar.gz"
  sha256 "a95a123f29a71f5a2eea0811e4590d59cbc92eccd407abe93c110c738fc4740b"
  license "MIT"
  head "https://github.com/kyleconroy/sqlc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "159376fbb6da52240161c2ac689432121ea7110838758552b735dcc6e4fb8180" => :big_sur
    sha256 "d6e1795618e027c9cf06506877f5ec6285d41c0f9e28b638335f8de522eec9a2" => :arm64_big_sur
    sha256 "debad9ab4e258cf867de532c0f6715ed69bebe970e43c0dcf875d6f1c4f761d4" => :catalina
    sha256 "be41455ec25177178d8d2c89d995c32cc82332c0ecb9bf5748d5619bdaff4c36" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/sqlc"
  end

  test do
    (testpath/"sqlc.json").write <<~SQLC
      {
        "version": "1",
        "packages": [
          {
            "name": "db",
            "path": ".",
            "queries": "query.sql",
            "schema": "query.sql",
            "engine": "postgresql"
          }
        ]
      }
    SQLC

    (testpath/"query.sql").write <<~EOS
      CREATE TABLE foo (bar text);

      -- name: SelectFoo :many
      SELECT * FROM foo;
    EOS

    system bin/"sqlc", "generate"
    assert_predicate testpath/"db.go", :exist?
    assert_predicate testpath/"models.go", :exist?
    assert_match "// Code generated by sqlc. DO NOT EDIT.", File.read(testpath/"query.sql.go")
  end
end
