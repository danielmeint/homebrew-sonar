class Sonar < Formula
  desc "CLI tool for SonarQube"
  homepage "https://github.com/SonarSource/sonarqube-cli"
  version "1.4.0.3748"
  license "LGPL-3.0-only"

  on_macos do
    on_arm do
      url "https://binaries.sonarsource.com/Distribution/sonarqube-cli/#{version}/macos/sonarqube-cli-#{version}-macos-arm64.bin"
      sha256 "2a23cbbd04c97204f84561032f4cf23f04a057d98f39c278805893fae54854f6"
    end
  end

  on_linux do
    on_intel do
      url "https://binaries.sonarsource.com/Distribution/sonarqube-cli/#{version}/linux/sonarqube-cli-#{version}-linux-x86-64.bin"
      sha256 "a57425c8f3d2eab1bae6628fc532f19180b022efd47a280d3eb718e1ac09d382"
    end

    on_arm do
      url "https://binaries.sonarsource.com/Distribution/sonarqube-cli/#{version}/linux/sonarqube-cli-#{version}-linux-arm64.bin"
      sha256 "3af62fcd65faca4b3bb4a3baae2bc9cbb427f25b189e5f6e0760c7d59b64185a"
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
