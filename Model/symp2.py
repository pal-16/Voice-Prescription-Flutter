import pickle
import pandas as pd
from sklearn.metrics import classification_report
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split
from sklearn.model_selection import cross_val_score
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import accuracy_score
from nltk.stem import PorterStemmer
from nltk.stem import WordNetLemmatizer
dtc = DecisionTreeClassifier()
lemma = WordNetLemmatizer()
post = PorterStemmer()
MODEL_FILENAME = "symptom_model.hdf5"
MODEL_LABELS_FILENAME = "symptom_labels.dat"
data = [line.rstrip('\n') for line in open('wordlist.txt','r')]


#read the csv files
df_training = pd.read_csv("Training.csv")
df_testing = pd.read_csv("Testing.csv")

#join the files and rename the column
df_main = pd.concat([df_training,df_testing],ignore_index='true')
df_main.rename(columns={"prognosis":"diseases"},errors="raise",inplace="true")

#clean the data
a = list(df_main.columns)
final_list1=[]
final_list2=[]
for str in a:
    temp = str.split('_')
    if(len(temp)<=2):
        final_list1.append(str)
        str1 = str.replace('_',' ')
        final_list2.append(str1)

df_main = df_main[final_list1]
df_main.rename(columns={final_list1[i]:final_list2[i] for i in range(len(final_list1))},inplace="true")
for str in final_list2:
    if str!='diseases':
        temp1=post.stem(str)
        temp2=lemma.lemmatize(str)
        if temp1!=str and temp1 in data:
            df_main[temp1]=df_main[str]
        if temp2!=str and temp2 in data:
            df_main[temp2]=df_main[str]


l=[]
n = ['continuous sneezing','yellowish skin','dehydration']
#remove columns with maximum zeros
for str in final_list2:
    temp = list(df_main[str])
    x = temp.count(0)
    l.append(x)
    if x>=4735 and str not in n:
        df_main.drop([str],axis=1,inplace=True)
df_main.drop(['excessive hunger','painful walking','phlegm','malaise'],axis=1,inplace=True)


lb = LabelEncoder()
lb.fit_transform(df_main['diseases'])
#slice symptoms column and assign it to a variable
X = df_main.iloc[:,:]
y = df_main['diseases']
X.drop(['diseases'],axis=1,inplace=True)
tempi = list(X.columns)
def columnlist():
    tempi = list(X.columns)
    return tempi


#X.drop(['Diseases'],axis=1,inplace=True)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=20)

#save the mappings of labelencoder and the final output
with open(MODEL_LABELS_FILENAME, "wb") as f:
    pickle.dump(lb, f)

#training
dtc.fit(X_train, y_train)

# Save the trained model to disk
pickle.dump(dtc,open(MODEL_FILENAME,'wb'))


