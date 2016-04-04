class Haxe313 < Formula
  desc "Multi-platform programming language"
  homepage "http://haxe.org"
  url "https://github.com/HaxeFoundation/haxe.git", :tag => "3.1.3", :revision => "7be30670b2f1f9b6082499c8fb9e23c0a6df6c28"

  conflicts_with "haxe", :because => "Differing versions of the same formula."

  depends_on "ocaml" => :build
  depends_on "camlp4" => :build
  depends_on "neko"

  def install
    # Build requires targets to be built in specific order
    ENV.deparallelize
    system "make", "OCAMLOPT=ocamlopt.opt", "ADD_REVISION=1"
    bin.mkpath
    system "make", "install", "INSTALL_BIN_DIR=#{bin}", "INSTALL_LIB_DIR=#{lib}/haxe"

    # Replace the absolute symlink by a relative one,
    # such that binary package created by homebrew will work in non-/usr/local locations.
    rm bin/"haxe"
    bin.install_symlink lib/"haxe/haxe"
  end

  def caveats; <<-EOS.undent
    Add the following line to your .bashrc or equivalent:
      export HAXE_STD_PATH="#{HOMEBREW_PREFIX}/lib/haxe/std"
    EOS
  end

  test do
    ENV["HAXE_STD_PATH"] = "#{HOMEBREW_PREFIX}/lib/haxe/std"
    system "#{bin}/haxe", "-v", "Std"
  end
end
