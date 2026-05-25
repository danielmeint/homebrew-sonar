class Sonar < Formula
  desc "CLI tool for SonarQube"
  homepage "https://github.com/SonarSource/sonarqube-cli"
  version "0.13.0.1692"
  license "LGPL-3.0-only"

  on_macos do
    on_arm do
      url "https://binaries.sonarsource.com/Distribution/sonarqube-cli/#{version}/macos/sonarqube-cli-#{version}-macos-arm64.exe"
      sha256 "d9f070b34f6d1dfc1040ff569134223c9695fdb8d01bd0d2d305410eb2552b13"
    end
  end

  on_linux do
    on_intel do
      url "https://binaries.sonarsource.com/Distribution/sonarqube-cli/#{version}/linux/sonarqube-cli-#{version}-linux-x86-64.exe"
      sha256 "9257362d3bec48d612dd039dfcd0b9f644ff66b6c07b71f2ff815c88a60a2fd4"
    end

    on_arm do
      url "https://binaries.sonarsource.com/Distribution/sonarqube-cli/#{version}/linux/sonarqube-cli-#{version}-linux-arm64.exe"
      sha256 "b6623fcb5bb644118d1048a215bcc9791097e1cea08f8e2cf71cf989601a1497"
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
