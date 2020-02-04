#! python
"""
Download by line from text file:
Usage: download.py -l <download_list> -d <save_directory>
"""
import sys, getopt
import os
import urllib

def download(input_list, output_directory):
    with open(input_list,'r') as f:
        urls = [line.strip() for line in f]
        print(urls)

    if not os.path.exists(input_list):
        print ("input_list(%s) not exist!" % (input_list))
        sys.exit()
    elif not os.path.exists(output_directory):
        print ("output_directory(%s) not exist!" % (output_directory))
        os.mkdir(output_directory)

    print("Download starting!")
    i = 0
    for url in urls:
        i = i + 1
        print("Downloading %d : %s" % (i, url))
        out_file = str(i) + "_" + url[url.rfind("/") + 1:]
        urllib.urlretrieve(url, out_file)
        print("Done %d : %s" % (i, out_file))
    print("Download finished!")

def main(argv):
    USAGE = "Usage: ddownload.py -l <download_list> -d <save_directory>"
    download_list = None
    save_directory = None

    # parse cmdline options/params
    try:
        opts, args = getopt.getopt(argv,"hl:d:",["download_list=","save_directory="])
    except getopt.GetoptError:
        print ("Invalid options!")
        sys.exit()

    if (len(opts) == 0):
        print (USAGE)
        sys.exit()

    for opt, arg in opts:
        if opt == '-h':
            print (USAGE)
            sys.exit()
        elif opt in ("-l", "--download_list"):
            download_list = arg
        elif opt in ("-d", "--save_directory"):
            save_directory = arg

    # downloading
    download(download_list, save_directory)

if __name__ == "__main__":
    main(sys.argv[1:])
