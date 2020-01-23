import string
import re
from math import floor
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer

meddata = [line.rstrip('\n') for line in open('wordlist2.txt','r')]
lem = WordNetLemmatizer()

timelist=['twice','thrice','once','one','two','three','four','five','six','seven','eight','nine']
medicine=[]
dosage=[]

def assembler():
    assembled=""
    for m in medicine:
        assembled+=m.capitalize()+" "

    assembly_string=""
    ct=0
    for d in dosage:
        if (d in timelist or d.isnumeric()) and ct==0:
            assembly_string+=d+"/day"
            ct+=1
        elif (d in timelist or d.isnumeric()) and ct>0 and dosage.index(d)<len(dosage)-1:
            assembly_string+=" X "+d+" "+dosage[dosage.index(d)+1]
    
    prescription={
            "medicine":assembled,
            "dosage":assembly_string
            }
    return prescription
    
def prescription(straw):
    global medicine
    global dosage
    str1 = straw.lower()
    
    str2 = str1.translate(straw.maketrans('', '', string.punctuation))

    tokens = word_tokenize(str2)

    stpwords = list(stopwords.words('english'))
    stpwords.append('per')
    stpwords.append('times')
    tokens1 = [word for word in tokens if word not in stpwords]

    #assmeble final list of keywords
    for word in tokens1:
      lem.lemmatize(word)
                            
    medicine = [word for word in tokens1 if word in meddata and word not in timelist or (word.isnumeric() and tokens1.index(word)!=len(tokens1)-1 and (tokens1[tokens1.index(word)+1][-4:-1]=="gra" or tokens1[tokens1.index(word)+1]=="mg"))]
    dosage=[word for word in tokens1 if (word not in meddata or word in timelist) and word not in medicine]

def pres_code(pres):
    prescrip=re.split('(days |month |months |year |years |week |weeks)',pres)
    if not prescrip[-1]:
        del(prescrip[-1])
    if(len(prescrip)==2):
        prescrip[0]=prescrip[0]+prescrip[1]
        del(prescrip[1])
    else:
        for i in range(1,len(prescrip)-floor(len(prescrip)/2)):
            prescrip[i-1]=prescrip[i-1]+prescrip[i]
            del(prescrip[i])
    pfinal={}
    for i in range(len(prescrip)):
        p1=str(prescrip[i])
        prescription(p1)
        pfinal["prescription"+str(i+1)]=assembler()
    return(pfinal)