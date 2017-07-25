{ config, pkgs, ... }:
{
  security.pki = {
    # from the example import mozillas certificates https://curl.haxx.se/docs/caextract.html
    certificateFiles = [ "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" ];
    # from the example black list some CAs
    caCertificateBlacklist = [ "WoSign" "WoSign China" "CA WoSign ECC Root" "Certification Authority of WoSign G2" ];
  };
}
