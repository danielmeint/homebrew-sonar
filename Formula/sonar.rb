class Sonar < Formula
  desc "CLI tool for SonarQube"
  homepage "https://github.com/SonarSource/sonarqube-cli"
  version "1.5.0.4158"
  license "LGPL-3.0-only"

  on_macos do
    on_arm do
      url "https://binaries.sonarsource.com/Distribution/sonarqube-cli/#{version}/macos/sonarqube-cli-#{version}-macos-arm64.bin"
      sha256 "181df66a25b6cab6a4428f782fe279e01374088c1f3240fd946f7b91d35457e6"
    end
  end

  on_linux do
    on_intel do
      url "https://binaries.sonarsource.com/Distribution/sonarqube-cli/#{version}/linux/sonarqube-cli-#{version}-linux-x86-64.bin"
      sha256 "dbd4ee20257f73010ad7f8a2c2552373039ee3610af252416e6f13f7ff915460"
    end

    on_arm do
      url "https://binaries.sonarsource.com/Distribution/sonarqube-cli/#{version}/linux/sonarqube-cli-#{version}-linux-arm64.bin"
      sha256 "596018ec03f6282588e6bde56904625a4abd0c65c3e4dc3e05a9ecd28381c644"
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
