from flask import Flask
from flask import request, jsonify
import pandas as pd
from sklearn.tree import DecisionTreeClassifier # Import Decision Tree Classifier
from sklearn.model_selection import train_test_split # Import train_test_split function
from sklearn import metrics #Import scikit-learn metrics module for accuracy calculation
import pickle 

app = Flask(__name__)

app.config["DEBUG"] = True


class Prevention:
    vent = 0.0
    nom = 0
    direction = 0.0
    def __init__(self,vent,nom,direction):
        self.vent=vent
        self.nom=nom
        self.direction=direction        
    
    def run(self):

        # initialize list of lists 
        data = [[self.vent,self.nom,self.direction]] 
        # Create the pandas DataFrame 
        test = pd.DataFrame(data, columns = ['ventMax','nom','direction'])
        #filename = 'SaveModelOrange.pkcls'
        filename = 'finalized_model.sav'
        loaded_model = pickle.load(open(filename, 'rb'))
        return loaded_model.predict(test)



@app.route('/', methods=['GET'])
def home():
    return ''"<h1>Pollution indice prediction</h1><p>This site is a prototype API for predict the pollution's indice with wind,direction and place values.</p>"



@app.route('/api/v1/prevision', methods=['GET'])
def api_prev():
    # Check if an ID was provided as part of the URL.
    # If ID is provided, assign it to a variable.
    # If no ID is provided, display an error in the browser.
    if 'wind' in request.args:
        wind = float(request.args['wind'])
    else:
        return "Error: No wind field provided. Please specify an wind value."

    if wind<0 or wind>100:
        return "Error: Values are aberrant"

    if 'place' in request.args:
        place = str(request.args['place'])
        if place == 'Logicoop':
            place=1
        elif place == 'Faubourg_Blanchot':
            place=2
        elif place == 'Anse_Vata':
            place=3
        elif place == 'Montravel':
            place=4
        else:
            return "Error: place isn't good, you have as possibilities : Logicoop/Faubourg_Blanchot/Anse_vata/Montravel"
    else:
        return "Error: No place field provided. Please specify an place value."

    if 'direction' in request.args:
        direction = float(request.args['direction'])
        if direction>360.0 or direction < 0:
            return "Error: direction need to be between 0.0 and 360.0"
    else:
        return "Error: No direction field provided. Please specify an direction value."


    prev = Prevention(wind,place,direction)
    tmp = prev.run()
    dic={"wind":wind,
        "place":str(request.args['place']),
        "direction":direction,        
        "indice":float(tmp[0])}

    # Use the jsonify function from Flask to convert our list of
    # Python dictionaries to the JSON format.
    return jsonify(dic)



if __name__ == "__main__":
    app.run(debug=True)