import string
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer

data = [line.rstrip('\n') for line in open('wordlist.txt','r')]
namedata=[line.rstrip('\n') for line in open('names.csv','r')]
gen=['mail','male','email','main','female','unknown']
lemma = WordNetLemmatizer()

result=[]
gender=[]
def namecatch(str):
    global result
    global gender
    str1 = str.lower()
    #removing punctuation
    str2 = str1.translate(str.maketrans('', '', string.punctuation))

    #tokenize all words
    tokens = word_tokenize(str2)

    #create list of all stopwords
    stpwords = list(stopwords.words('english'))
    tokens1 = [word for word in tokens if word not in stpwords]

    #create final list of keywords
    for word in tokens1:
      lemma.lemmatize(word)

    result = [word for word in tokens1 if (word not in data or word in namedata)]
    gender=[word for word in tokens1 if word in gen]
    
    if gender:
        if gender[0]=="mail" or gender[0]=="main" or gender[0]=="email":
            gender[0]='male'

def name_code(name):
    namecatch(name)
    
    if not result:
        result.append("None")
    result[0]=result[0].capitalize()
    
    while len(result)>1 and result[1].isnumeric()==False:
        i=1
        if result[i].isnumeric()==False:
            result[0]=result[0]+" "+result[i].capitalize()
            del(result[i])
        else:
            result[0]=result[0].capitalize()
            
    if not gender:
        gender.append('g')
    if len(result)==1:
        result.append("NA")
        
    dict_name={
            "name": result[0],
            "age": result[1],
            "gender": gender[0].capitalize()}
    return dict_name