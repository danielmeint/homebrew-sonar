class Sonar < Formula
  desc "CLI tool for SonarQube"
  homepage "https://github.com/SonarSource/sonarqube-cli"
  version "0.11.0.1439"
  license "LGPL-3.0-only"

  on_macos do
    on_arm do
      url "https://binaries.sonarsource.com/Distribution/sonarqube-cli/#{version}/macos/sonarqube-cli-#{version}-macos-arm64.exe"
      sha256 "981c11ce4f2bbc3e97da4247169f0226cec66bf4e8b94f6029752c44c20e7850"
    end
  end

  on_linux do
    on_intel do
      url "https://binaries.sonarsource.com/Distribution/sonarqube-cli/#{version}/linux/sonarqube-cli-#{version}-linux-x86-64.exe"
      sha256 "c7c12261cf7e5f465e4bf3170a84a09a1e2c8bdcdb1d24fb46f2a4ad5ad8615b"
    end

    on_arm do
      url "https://binaries.sonarsource.com/Distribution/sonarqube-cli/#{version}/linux/sonarqube-cli-#{version}-linux-arm64.exe"
      sha256 "a14d252c32f238c85bfe87428127e7aedecec81aedcf2107ced8ea1b679411ca"
    end
  end

  def install
    binary = Dir["sonarqube-cli-*"].first
    bin.install binary => "sonar"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sonar --version")
  end
end
