from flask import Flask, request, jsonify
import pickle
import numpy as np

app = Flask(__name__)

# Load the trained model
try:
    with open('nutrition_model.pkl', 'rb') as f:
        model = pickle.load(f)
except Exception as e:
    print(f"Error loading model: {e}")
    model = None

@app.route('/predict', methods=['POST'])
def predict():
    if model is None:
        return jsonify({'error': 'Model not loaded'}), 500

    try:
        data = request.json
        # Validate input
        required_fields = ['weight', 'height', 'age', 'gender', 'fitness_goal']
        if not all(field in data for field in required_fields):
            return jsonify({'error': 'Missing required fields'}), 400

        # Prepare input for model
        gender_map = {'Male': 1, 'Female': 0}
        goal_map = {'Weight Loss': 0, 'Muscle Gain': 1, 'Maintenance': 2, 'Athletic Performance': 2}
        input_data = np.array([[
            float(data['weight']),
            float(data['height']),
            float(data['age']),
            gender_map.get(data['gender'], 0),  # Default to Female if invalid
            goal_map.get(data['fitness_goal'], 2)  # Default to Maintenance
        ]])

        # Make prediction
        prediction = model.predict(input_data)[0]
        return jsonify({
            'calories': int(prediction[0]),
            'protein': int(prediction[1]),
            'carbs': int(prediction[2]),
            'fat': int(prediction[3])
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)