const functions = require('firebase-functions');
const admin = require('firebase-admin');
// ref https://stackoverflow.com/questions/42755131/enabling-cors-in-cloud-functions-for-firebase
const cors = require('cors')({origin: true});
// var serviceAccount = require("/home/bmabir/dev/tran-dao-8e837f43806d.json");
admin.initializeApp({
    credential: admin.credential.applicationDefault()
});
const db = admin.firestore();

exports.helloWorld = functions.https.onRequest((request, response) => {
    cors(request, response, () => {
        response.status(200).send("Hello from tran dao server!");
    });
});

exports.get_relief = functions.https.onRequest((request, response) => {
    cors(request, response, () => {
        const docRef = db.collection('relief');
        docRef.get()
        .then(snapshot => {
            let arrayR = snapshot.docs.map(doc => {
                return doc.data();
            }); 
            return response.status(200).json(arrayR);        
        }).catch(err => {
            console.log('Error getting document', err);
            return response.status(500).send("Error getting relief document")
        });
    });
});

exports.get_infected = functions.https.onRequest((request, response) => {
    cors(request, response, () => {
        const docRef = db.collection('infected');
        docRef.get()
        .then(snapshot => {
            let arrayR = snapshot.docs.map(doc => {
                return doc.data();
            }); 
            return response.status(200).json(arrayR);        
        }).catch(err => {
            console.log('Error getting document', err);
            return response.status(500).send("Error getting infected document")
        });
    });
});
