#! python
"""
Download by line from text file:
Usage: download.py <download_list> <save_directory>
"""
import sys
import urllib

download_list = sys.argv[1]
save_directory = sys.argv[2]

with open(download_list,'r') as f:
    urls = [line.strip() for line in f]
    print(urls)

i = 0
for url in urls:
    i = i + 1
    print("Downloading %d : %s" % (i, url))
    out_file = str(i) + "_" + url[url.rfind("/") + 1:]
    urllib.urlretrieve(url, out_file)
    print("Done %d : %s" % (i, out_file))
