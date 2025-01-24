{ config, lib, ... }: {
  imports = [ ./persistence.nix ];

  config = lib.mkIf config.programs.gpg.enable {
    home.needsPersistence.directories = [{
      directory = ".local/share/gnupg";
      method = "bindfs"; # allow home-manager to manage keyring
    }];

    programs.gpg = {
      homedir = lib.mkDefault "${config.home.homeDirectory}/.local/share/gnupg";
      settings = {
        personal-cipher-preferences = lib.mkDefault "AES256 AES192 AES";
        personal-digest-preferences = lib.mkDefault "SHA512 SHA384 SHA256";
        personal-compress-preferences =
          lib.mkDefault "ZLIB BZIP2 ZIP Uncompressed";
        default-preference-list = lib.mkDefault
          "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
        cert-digest-algo = lib.mkDefault "SHA512";
        s2k-digest-algo = lib.mkDefault "SHA512";
        s2k-cipher-algo = lib.mkDefault "AES256";
        charset = lib.mkDefault "utf-8";
        fixed-list-mode = lib.mkDefault true;
        no-comments = lib.mkDefault true;
        no-emit-version = lib.mkDefault true;
        no-greeting = lib.mkDefault true;
        keyid-format = lib.mkDefault "0xlong";
        list-options = lib.mkDefault "show-uid-validity";
        verify-options = lib.mkDefault "show-uid-validity";
        with-fingerprint = lib.mkDefault true;
        require-cross-certification = lib.mkDefault true;
        no-symkey-cache = lib.mkDefault true;
        use-agent = lib.mkDefault true;
        throw-keyids = lib.mkDefault true;
      };
      scdaemonSettings.disable-ccid = lib.mkDefault true;
    };
  };
}
