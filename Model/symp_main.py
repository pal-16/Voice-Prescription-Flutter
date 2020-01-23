import pickle
import numpy as np
from symp1 import testfunction
from symp2 import columnlist
MODEL_FILENAME = "symptom_model.hdf5"
MODEL_LABELS_FILENAME = "symptom_labels.dat"
data = [line.rstrip('\n') for line in open('wordlist.txt','r')]



def symp_code(input_str):
    #load the model
    with open(MODEL_LABELS_FILENAME, "rb") as f:
        lb = pickle.load(f)
    load_model = pickle.load(open(MODEL_FILENAME, 'rb'))

    #lets start with the testing
    tempi = columnlist()
    #print(tempi)
    tokens1 = testfunction(input_str)
    #print(tokens1)

    tokens = []
    #tokens = testfunction(test_input)
    for i in range(len(tokens1)):
        if tokens1[i] in data:
            if(tokens1[i] in tempi):
                tokens.append(tokens1[i])
        else:
            if(i!=len(tokens1)-1):
                temp = tokens1[i]+' '+tokens1[i+1]
                if(temp in tempi):
                    tokens.append(temp)
    inp_data = np.zeros(len(tempi))
    inp_data = [inp_data]
    for str in tokens:
        if str in tempi:
            i = tempi.index(str)
            inp_data[0][i]=1
    if(np.sum(inp_data)==0):
        result="__The patient is Healthy__"
    else:
        prediction = load_model.predict(inp_data)
        result=("The patient may be suffering from "+ prediction)
    return result


