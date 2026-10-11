AUXIS SDDM Qt 6 theme

Preview from this directory:
  sddm-greeter-qt6 --test-mode --theme "$PWD"

HiJO display font setup:
1. Download HiJO from https://www.1001fonts.com/hijo-font.html
2. Extract hijo.zip. Copy the HiJO Regular OTF into assets/ and rename it
   to HiJO-Regular.otf. Keep the font's license file.
3. Preview again. The AUXIS wordmark and large clock use HiJO; small UI labels
   use a mono font for readability. If the font file is absent, Qt falls back
   to a system font.

Test in greeter test mode before setting it as the active login theme.
