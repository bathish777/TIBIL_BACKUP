const express = require('express');
const cors = require('cors');
const { google } = require('googleapis');


const app = express();
const PORT = 3000;


app.use(cors());
app.use(express.json());


app.get('/access-token', async (req, res) => {
   try {
       const accessToken = await getAccessToken();
       res.status(200).json({ code: 2000, message: 'Service is available.', accessToken });
   } catch (error) {
       res.status(500).json({ code: 5000, message: 'Error fetching access token', error: error.message });
   }
});


async function getAccessToken() {
   const SCOPES = ['https://www.googleapis.com/auth/cloud-platform'];
   const key = require('/home/ibrahim/Downloads/dev-dms-soundbox-firebase-adminsdk-8ui3c-4cf9360cdb.json');
   const jwtClient = new google.auth.JWT(
       key.client_email,
       null,
       key.private_key,
       SCOPES,
       null
   );
   const tokens = await jwtClient.authorize();
   return tokens.access_token;
}


app.listen(PORT, () => {
   console.log(`Server is running on http://localhost:${PORT}`);
});
