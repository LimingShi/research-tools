#!/Users/slmlaptop/anaconda/bin/python
import webbrowser
import argparse
str1 = 'https://ieeexplore.ieee.org/search/searchresult.jsp?action=search&searchField=Search_All&matchBoolean=true&queryText='

parser = argparse.ArgumentParser(description='Track papers on IEEE. Written by Liming Shi, Audio Analysis Lab, Aalborg University, Denmark. Contact: ls@create.aau.dk or limingshi12@foxmail.com')
parser.add_argument('-j', nargs='*', default=[], help='The abbreviation of the journals and conferences, e.g., -j tsp spl')
parser.add_argument('-c', action='store_true', help='Sorted by citations with sorting by newest as default.')
parser.add_argument('-sc', nargs='*', default=[], help='Search content, e.g., -sc speech enhancement. The default is not specifying the content.')
year_range = ['2017', '2021']
parser.add_argument('-tr', nargs=2, default=year_range, help='Time range of the searching results, e.g., -tr 2017 2021 (from 2017 to 2021). The default is 2017 to 2021.')


def get_options(args):
  str2 = ''
  str2 = str2 + '&highlight=true&returnType=SEARCH&matchPubs=true&'
  if args.c:
    str2 = str2 + 'sortType=paper-citations&'
  else:
    str2 = str2 + 'sortType=newest&'
  str2 = str2 + 'ranges=' + args.tr[0] + '_' + args.tr[1] + '_Year&'
  str2 = str2 + 'returnFacets=ALL&rowsPerPage=100&pageNumber=1'
  return str2


def AbbrevToFull(args):
  switcher = {'spl': 'IEEE Signal Processing Letters',
              'tsp': 'IEEE Transactions on Signal Processing',
              'taslp': 'IEEE/ACM Transactions on Audio, Speech, and Language Processing',
              'pami': 'IEEE Transactions on Pattern Analysis and Machine Intelligence',
              'jstsp': 'IEEE Journal of Selected Topics in Signal Processing',
              'spm': 'IEEE Signal Processing Magazine',
              'icassp': 'icassp',
              'waspaa': 'waspaa'
              }
  if args.j:
    nI = len(args.j)
    keyword_str = switcher.get(args.j[0])
    keyword_str = keyword_str.replace(" ", "%20")
    keyword_str = keyword_str.replace("/", "%2F")
    str2 = ''
    str2 = str2 + '(%22Publication%20Title%22:' + keyword_str + ')'
    for i in range(1, nI):
      key = args.j[i]
      keyword_str = switcher.get(key)
      keyword_str = keyword_str.replace(" ", "%20")
      keyword_str = keyword_str.replace("/", "%2F")
      str2 = '(' + str2 + '%20OR%20%22Publication%20Title%22:' + keyword_str + ')'
  else:
    # pick selected journal/conference to search as default
    journal_list = ['taslp', 'spl', 'tsp', 'jstsp', 'spm', 'icassp', 'waspaa']
    keyword_str = switcher.get(journal_list[0])
    keyword_str = keyword_str.replace(" ", "%20")
    keyword_str = keyword_str.replace("/", "%2F")
    str2 = ''
    str2 = str2 + '(%22Publication%20Title%22:' + keyword_str + ')'
    for i in range(1, len(journal_list)):
      key = journal_list[i]
      keyword_str = switcher.get(key)
      keyword_str = keyword_str.replace(" ", "%20")
      keyword_str = keyword_str.replace("/", "%2F")
      str2 = '(' + str2 + '%20OR%20%22Publication%20Title%22:' + keyword_str + ')'
  if args.sc:
    keyword_str = ' '.join(args.sc)
    keyword_str = keyword_str.replace(" ", "%20")
    str2 = '(' + str2 + '%20AND%20%22All%20Metadata%22:' + keyword_str + ')'
  return str2


if __name__ == '__main__':
  args = parser.parse_args()
  # Abbreviation=args.Abbreviation
  str2 = AbbrevToFull(args)
  str3 = get_options(args)
  webbrowser.open(str1 + str2 + str3)
