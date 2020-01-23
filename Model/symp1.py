import string
import nltk
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer

data = [line.rstrip('\n') for line in open('wordlist.txt','r')]
lemma = WordNetLemmatizer()

def testfunction(str):
    #convert to lowercase
    str1 = str.lower()

    #removing punctuations from string
    str2 = str1.translate(str1.maketrans('', '', string.punctuation))

    #tokenize all words
    tokens = word_tokenize(str2)

    #create list of all stopwords
    stpwords = list(stopwords.words('english'))
    tokens1 = [word for word in tokens if word not in stpwords]

    #create final list of keywords
    for word in tokens1:
      lemma.lemmatize(word)

    #result = [word for word in tokens1 if word in data]

    return tokens1



