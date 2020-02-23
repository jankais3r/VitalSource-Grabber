## Background
[VitalSource](https://www.vitalsource.com) is an online store for text books. Unfortunately, access to the purchased content is extremely limited. You have to use VitalSource's apps to read the books (no PDFs) and printing is limited to 2 pages at a time. Those 2 pages will also be watermarked with your e-mail address, and will be provided as an image, hence becoming non-searchable. Great. There are several other repositories promising download of VitalSource books, but none of them worked for me, so I wrote my own.

## Requirements
1. macOS (the script should run on any OS, but this guide is focused on macOS)
2. VitalSource account with purchased book(s)
3. [VitalSource Bookshelf Mac app](https://support.vitalsource.com/hc/en-us/articles/360014107913-Mac)
4. Requests Python library (`pip3 install requests`)
5. [ImageMagick](https://imagemagick.org/index.php) (`brew install imagemagick`)
6. Man-in-the-middle proxy ([Proxie](https://proxie.app)/[mitmproxy](https://mitmproxy.org)/[Charles Proxy](https://www.charlesproxy.com))

## Process
1. Download individual pages
2. Remove watermarks
3. Add page numbers
4. Merge individual pages into a single PDF file
5. OCR the PDF to make it searchable (not covered by this guide)

## Single vs Double page printing
As mentioned previously, VitalSource allows you to print max 2 pages at a time. This is an important detail, because while each book might be set in a different format (A5/A4/custom), the printed layout is always in A4 size. Therefore, two A5-sized pages of text will not fully fill two A4 printed pages.

If we ask VitalSource to print pages one by one, the content on all pages will be equally distributed. If we choose to print by 2 pages, and the original book was set in smaller than A4 format, the even pages will be generally almost empty. To better illustrate this difference, please refer to the following image.
![Single vs Double page printing](https://github.com/jankais3r/VitalSource-Grabber/blob/master/images/single_vs_double.png)

## Step 1 (Download individual pages)
To download the pages, you'll want to use either `download_single.py` or `download_double.py` script, depending on which variant you prefer. I would recommend downloading first 10 pages in both variants and deciding based on the results (will vary for each book).

Before you run the script, you'll want to modify some parameters on rows 9-11: `IBAN`, `VitalSourceAPIKey`, and `VitalSourceAccessToken`.
While IBAN is pretty self-explanatory, the other two parameters will require some work on your part. You'll need to capture the Bookshelf app's network traffic using one of the recommended debug proxies and extract the two header properties from it. Once you have the proxy in place, open your book in the Bookshelf app and print any page. Then check your proxy log for traffic to the `https://print.vitalsource.com/` domain and check the request headers.
![Proxie](https://github.com/jankais3r/VitalSource-Grabber/blob/master/images/proxie.png)

Once you've updated the 3 parameters, run the script. It will slowly (the download is throttled in order to avoid triggering alerts) download the requested pages into a new folder in your Downloads.

## Step 2 & 3 (Remove watermarks & Add page numbers)
The script `process.sh` takes care of the cleanup of the downloaded pages. First, it removes the watermarks, then it adds page number to the bottom of each page.
![Process stages](https://github.com/jankais3r/VitalSource-Grabber/blob/master/images/process_stages.png)

Just run the script with IBAN of the downloaded book as the only parameter and you should be good.
Like this `./watermark.sh 9781000710899`

## Step 4 (Merge individual pages into a single PDF file)
This one is easy - just select all images, right-click and select Quick Actions > Create PDF
![Merge pages](https://github.com/jankais3r/VitalSource-Grabber/blob/master/images/merge.png)

## Step 5 (OCR the PDF to make it searchable)
To make the final PDF searchable, you need to run Optical Character Recognition (OCR) on it. There are many commercial tools that can do this, e.g. Adobe Acrobat.
