# pdf tools for the terminal; pdfarranger (documents.nix) is the gui for reordering pages
{pkgs, ...}: let
  # english (+ osd, page orientation, which ocrmypdf needs) instead of every language
  # tesseract ships by default (~1 GB)
  ocrmypdf = pkgs.ocrmypdf.override {
    tesseract = pkgs.tesseract.override {enableLanguages = ["eng" "osd"];};
  };
in {
  home.packages = with pkgs; [
    poppler-utils # pdftotext, pdfinfo, pdfimages, pdfunite (merge), pdfseparate (split), pdftoppm (to png)
    qpdf # pages, merge, split, rotate, decrypt: `qpdf in.pdf --pages . 1-3 -- out.pdf`
    ghostscript # shrink: `gs -sDEVICE=pdfwrite -dPDFSETTINGS=/ebook -o small.pdf in.pdf`
    mupdf # `mutool` (extract, clean, draw) and a fast keyboard viewer
    pdfcpu # watermark, stamp, encrypt, n-up, validate: `pdfcpu watermark add ...`
    ocrmypdf # scanned pdf -> searchable text layer: `ocrmypdf scan.pdf out.pdf`
    img2pdf # images -> pdf without re-encoding: `img2pdf *.jpg -o out.pdf`
    pdfgrep # grep inside pdfs: `pdfgrep -ri word .`
    exiftool # read or strip metadata: `exiftool -all= file.pdf`
  ];
}
