
from collections import Counter

def count_symbols(text):
    text_out_spaces = text.replace(' ','')
    str_in_dict = dict(Counter(text_out_spaces))
    for k,v in str_in_dict.items():
        print(f"{k}-{v}")

count_symbols(input())