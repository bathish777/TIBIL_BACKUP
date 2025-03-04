const express = require('express');
const cors = require('cors');

const app = express();
const PORT = 3001;
function generateRandomIdentification() {
  return Math.floor(100000 + Math.random() * 900000).toString(); // Generates a 6-digit random number
}
// Middleware
app.use(cors());
app.use(express.json());

// Middleware to check guest token
const checkGuestToken = (req, res, next) => {
    const guestToken = req.headers['guest_token'];
    if (!guestToken) {
      return res.status(401).json({ code: 401, message: 'Unauthorized: Guest token missing' });
    }
    next();
  };
  
  // Middleware to check access token
  // const checkAccessToken = (req, res, next) => {
  //   const accessToken = req.headers['access_token'];
  //   if (!accessToken) {
  //     return res.status(401).json({ code: 401, message: 'Unauthorized: Access token missing' });
  //   }
  //   next();
  // };

// Middleware to check access token
const checkAccessToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ code: 401, message: 'Unauthorized: Access token missing or invalid' });
  }

  const accessToken = authHeader.split(' ')[1]; // Extract the token from "Bearer <token>"
  if (!accessToken) {
    return res.status(401).json({ code: 401, message: 'Unauthorized: Access token missing' });
  }

  // Optionally, you can validate the token here (e.g., using a library like jsonwebtoken)
  // For now, we'll just assume the token is valid if it exists.

  next();
};
//sample

  const posts = [
    { id: 1, title: 'ibrahim', home: 'kerala' },
    { id: 2, title: 'adithya', home: 'kerala' },
  ];
  
  // GET /api/posts - Fetch all posts
  app.get('/api/posts', (req, res) => {
    try {
      // Simulate a delay to mimic a real API
      setTimeout(() => {
        res.status(200).json({
          status: 'success',
          data: posts,
        });
      }, 1000); // 1-second delay
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: 'Failed to fetch posts',
      });
    }
  });
  

  
  
// Routes
app.get('/ping', (req, res) => {
    res.status(200).json({ code: 2000, message: 'Service is available.' });
});

app.post('/user/init/get', (req, res) => {
    res.status(200).json({
        code: 2000,
        data: {
            vmn_list: [
                { vmn_number: '8921385682', is_primary: true },
                { vmn_number: '35652356523', is_primary: false },
            ],
            guest_token: 'sdfsjsjfcjsdfhjsfdssdsdmnfsdnfdsfdsfkjdmnzxmccess',
            poll_interval_secs: 30, 
        },
    });
});

app.post('/user/tnc/get',checkGuestToken, (req, res) => {
    res.status(200).json({
        code: 2000,
        message:
            'By accessing, downloading, or using this file, you agree to abide by these Terms and Conditions. This file is intended for personal or authorized use only, and any modification, reproduction, distribution, or unauthorized sharing is strictly prohibited. If the file contains confidential information, you are responsible for maintaining its security and ensuring it is not disclosed to unauthorized parties. The content within this file may be protected by copyright, trademarks, or other intellectual property laws, and any third-party materials remain the property of their respective owners. This file is provided "as is" without any warranties, express or implied, and the owner assumes no liability for any errors, omissions, or damages resulting from its use. Under no circumstances shall the owner be held liable for direct, indirect, incidental, special, or consequential damages arising from the use or inability to use this file. The owner reserves the right to update or modify these terms at any time without prior notice, and continued use of the file after any changes constitutes acceptance of the revised terms. These Terms and Conditions are governed by the laws of [Your Country/State], and any disputes will be resolved in accordance with local legal jurisdiction. By proceeding, you acknowledge that you have read, understood, and agree to these Terms and Conditions.By accessing, downloading, or using this file, you agree to abide by these Terms and Conditions. This file is intended for personal or authorized use only, and any modification, reproduction, distribution, or unauthorized sharing is strictly prohibited. If the file contains confidential information, you are responsible for maintaining its security and ensuring it is not disclosed to unauthorized parties. The content within this file may be protected by copyright, trademarks, or other intellectual property laws, and any third-party materials remain the property of their respective owners. This file is provided "as is" without any warranties, express or implied, and the owner assumes no liability for any errors, omissions, or damages resulting from its use. Under no circumstances shall the owner be held liable for direct, indirect, incidental, special, or consequential damages arising from the use or inability to use this file. The owner reserves the right to update or modify these terms at any time without prior notice, and continued use of the file after any changes constitutes acceptance of the revised terms. These Terms and Conditions are governed by the laws of [Your Country/State], and any disputes will be resolved in accordance with local legal jurisdiction. By proceeding, you acknowledge that you have read, understood, and agree to these Terms and Conditions.' 
            
    });
});

app.post('/user/vmn',checkGuestToken, (req, res) => {
    res.status(200).json({
        code: 2000,
        message: 'success',
    });
});



app.post('/user/devices', checkGuestToken,(req, res) => {
    const { vmn_code } = req.body;

    // // Check if vmn_code is provided
    if (!vmn_code) {
        return res.status(400).json({
            code: 4000,
            message: 'Vmn_code is required.',
        });
    }


    res.status(200).json({
        code: 2000,
        mobile_number: '8921385682',  // Example mobile number
    });
});







app.post('/user/accounts/get',checkGuestToken, (req, res) => {
  const { mobile } = req.body;

  if (mobile === '8921385682') {
      return res.status(200).json({
          code: 2000,
          data: {
              accounts: [
                  {
                      customerId: '456789',
                      customerReferenceNumber: '5674267906535678',
                      customerFullName: 'Ibrahim',
                      mobileNumber: '8921385682',
                      accountId: 'xxxxxxxxxxxx3984',
                      accountType: 'SAVINGS',
                      accountStatus: 'ACCOUNT OPEN REGULAR',
                      IFSCCode: 'JSFB0004534',
                      aeba: 'Y',
                  },
                  {
                    customerId: '456786',
                    customerReferenceNumber: '5674267906535678',
                    customerFullName: 'Ibrahim',
                    mobileNumber: '8921385682',
                    accountId: 'xxxxxxxxxxxx3967',
                    accountType: 'CURRENT',
                    accountStatus: 'ACCOUNT OPEN REGULAR',
                    IFSCCode: 'JSFB0004534',
                    aeba: 'Y',
                },
              ],
             
          },
      });
  }

  return res.status(404).json({
      code: 4040,
      message: 'Mobile number not found.',
  });
});




app.post('/user/account/upi/get',checkGuestToken, (req, res) => {
    const { mobile } = req.body;

    // if (!mobile_number) {
    //     // Return an error response if the mobile number is not provided
    //     return res.status(400).json({
    //         code: 4000,
    //         message: 'Mobile number is required.',
    //     });
    // }

    // Handle the specific mobile number for a predefined response
    if (mobile === '8921385682') {
        return res.status(200).json({
            code: 2000,
            data: [
                {
                    base64Qrcode: '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',

                    customer_name: 'IbrahimP',
                    customer_vpa: 'ABC Provisions',
                },
                {
                    base64Qrcode: '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',

                    customer_name: 'IbrahimD',
                    customer_vpa: 'Lulu Group',
                },
                {
                    base64Qrcode: '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',

                    customer_name: 'IbrahimZ',
                    customer_vpa: 'Chocolate Factory',
                },
            ],
        });
    } else {
        // Return a default response for other mobile numbers
        return res.status(404).json({
            code: 4004,
            message: 'No data found for the provided mobile number.',
        });
    }
});


// Backend API to generate OTP
app.post('/user/otp',checkGuestToken, (req, res) => {
    const { mobile } = req.body;
  
    // Check if mobile_number is provided, vmn_code is no longer required
    if (!mobile) {
      return res.status(400).json({
          code: 4000,
          message: 'Mobile number is required.',
      });
  }

  // Generate a random identification code (OTP)
  const identification = generateRandomIdentification();

  // Simulate sending the OTP (e.g., via SMS or push notification)
  console.log(`OTP sent to ${mobile}: ${identification}`);

    // Simulating OTP generation and response
    res.status(200).json({
      code: 2000,
      data: {
       identification: identification, // Random OTP
        mobile: mobile, // Mobile number from request
      },
    });
  });
  
 

app.patch('/user/otp', checkGuestToken,(req, res) => {
    try {
        const { otp, mobile_number, device_id, identification } = req.body;

        // Validate input
        if (!otp || !mobile_number || !device_id || !identification) {
            return res.status(400).json({
                code: 400,
                message: '',
            });
        }

        // Return a success response directly, regardless of OTP verification
        res.status(200).json({
            success: true,
            message: 'OTP request received successfully.',
            data: req.body, // Sending the received request body back (optional)
        });
    } catch (error) {
        // Default to 422 if error.code is not provided
        const statusCode = error.code || 422;
        res.status(statusCode).json({
            code: statusCode,
            message: error.message || 'An error occurred during OTP processing.',
        });
    }
});

// app.post('/user/secrets', checkGuestToken,(req, res) => {
//     const { mobile_number, mpin } = req.body;

//     // Input validation
//     if (!mobile_number || !mpin) {
//         return res.status(422).json({
//             code: 422,
//             message: 'Validation exception: Missing required fields'
//         });
//     }

//     // For demonstration, returning a success response with tokens
//     res.status(200).json({
//         code: 2000,
//         data: {
//             uuid: '123payBankIbr', // Example user UUID
//             access_token: 'iVBORw0KGgoAAAANSUhEUgAAAlgAAAQaCAIAAAAQRJHWAACAAElEQVR42uzdebQV1Z33/ /vHs1avleTX/azn6d/KahXBCZO2FaJJJ4b8YkfMk8e222hit9HE2CYYTdoMKlwVEASTiKjgEHECUQ ERZXAAHBhFRFBEAQ0oMyhXLncegAt3+H3P3', // Example access token
//             refresh_token: 'iVBORw0KGgoAAAANSUhEUgAAAlgAAAQaCAIAAAAQRJHWAACAAElEQVR42uzdebQV1Z33/ /vHs1avleTX/azn6d/KahXBCZO2FaJJJ4b8YkfMk8e222hit9HE2CYYTdoMKlwVEASTiKjgEHECUQ ERZXAAHBhFRFBEAQ0oMyhXLncegAt3+H3P3', // Example refresh token
//             default_preferences: {
//                 language: 'en',
//                 mute: '0' // User's default preferences
//             }
//         }
//     });
// });
app.post('/user/secrets', checkGuestToken, (req, res) => {
  const { mobile_number, mpin } = req.body;

  // Input validation
  if (!mobile_number || !mpin) {
    return res.status(422).json({
      code: 422,
      message: 'Validation exception: Missing required fields',
    });
  }

  // For demonstration, returning a success response with tokens
  res.status(200).json({
    code: 2000,
    data: {
      uuid: '123payBankIbr', // Example user UUID
      access_token: 'iVBORw0KGgoAAAANSUhEUgAAAlgAAAQaCAIAAAAQRJHWAACAAElEQVR42uzdebQV1Z33/ /vHs1avleTX/azn6d/KahXBCZO2FaJJJ4b8YkfMk8e222hit9HE2CYYTdoMKlwVEASTiKjgEHECUQ ERZXAAHBhFRFBEAQ0oMyhXLncegAt3+H3P3', // Example access token
      refresh_token: 'iVBORw0KGgoAAAANSUhEUgAAAlgAAAQaCAIAAAAQRJHWAACAAElEQVR42uzdebQV1Z33/ /vHs1avleTX/azn6d/KahXBCZO2FaJJJ4b8YkfMk8e222hit9HE2CYYTdoMKlwVEASTiKjgEHECUQ ERZXAAHBhFRFBEAQ0oMyhXLncegAt3+H3P3', // Example refresh token
      default_preferences: {
        language: 'en',
        mute: '0', // User's default preferences
      },
    },
  });
});
app.put('/user/preferences', checkAccessToken, (req, res) => {
  res.status(200).json({
    code: 2000,
    message: 'USER DETAILS UPDATED SUCCESSFULLY',
  });
});

app.post('/payment/create', checkAccessToken, (req, res) => {
  const { pid, name, amount, date, vpa } = req.body;

  // Validate required fields
  if (!pid || !name || !amount || !date || !vpa) {
    return res.status(400).json({ code: 4000, message: 'Missing required parameters' });
  }

  // Create a new payment object with dynamic vpa
  const newPayment = {
    pid,
    name,
    amount,
    date,
    vpa, // Add vpa dynamically from the request body
  };

  // Add the new payment to the payments array
  payments.push(newPayment);

  return res.status(200).json({
    code: 2000,
    message: 'Payment created successfully',
    data: newPayment,
  });
});

// Shared payments array
const currentDate = new Date().toISOString();

let payments = [
  
  { pid: 1, name: 'kiran', amount: 100, date: currentDate, vpa: 'test@upi' },
  { pid: 2, name: 'kiran', amount: 100, date: currentDate, vpa: 'test@upi' },

  { pid: 3, name: 'kiran', amount: 100, date: currentDate, vpa: 'test@upi' },
  { pid: 4, name: 'kian', amount: 180, date: currentDate, vpa: 'test@upi' },
  { pid: 5, name: 'kian', amount: 180, date: currentDate, vpa: 'test@upi' },

  










  

];

console.log(payments);

// Endpoint to fetch payments with pagination
// app.post('/payment/get', (req, res) => {
//   const { uuid, vpa, date, lastPid } = req.body;

//   if (!uuid || !vpa || !date) {
//     return res.status(400).json({ code: 4000, message: 'Missing required parameters' });
//   }

//   // Filter payments after lastPid
//   const newPayments = payments.filter((payment) => payment.pid > (lastPid || 0));

//   if (newPayments.length > 0) {
//     return res.status(200).json({
//       code: 2000,
//       data: {
//         payments: newPayments,
//       },
//     });
//   } else {
//     return res.status(404).json({ code: 1000, message: 'No more payments' });
//   }
// });
// app.post('/payment/get', (req, res) => {
//     const { uuid, vpa, date, lastPid } = req.body;
  
//     if (!uuid || !vpa || !date) {
//       return res.status(400).json({ code: 4000, message: 'Missing required parameters' });
//     }
  
//     // Filter payments for today's date
//     const today = new Date().toISOString().split('T')[0]; // Get today's date in YYYY-MM-DD format
//     const filteredPayments = payments.filter((payment) => {
//       const paymentDate = new Date(payment.date).toISOString().split('T')[0];
//       return paymentDate === today;
//     });
  
//     // Filter payments after lastPid
//     const newPayments = filteredPayments.filter((payment) => payment.pid > (lastPid || 0));
  
//     if (newPayments.length > 0) {
//       return res.status(200).json({
//         code: 2000,
//         data: {
//           payments: newPayments,
//         },
//       });
//     } else {
//       return res.status(404).json({ code: 1000, message: 'No more payments' });
//     }
//   });
// app.post('/payment/get', (req, res) => {
//     const { uuid, vpa, date, lastPid } = req.body;
  
//     if (!uuid || !vpa || !date) {
//       return res.status(400).json({ code: 4000, message: 'Missing required parameters' });
//     }
  
//     // Get today's date in YYYY-MM-DD format (UTC)
//     const today = new Date().toISOString().split('T')[0];
  
//     // Filter payments for today's date
//     const filteredPayments = payments.filter((payment) => {
//       const paymentDate = new Date(payment.date).toISOString().split('T')[0];
//       return paymentDate === today;
//     });
  
//     // Filter payments after lastPid
//     const newPayments = filteredPayments.filter((payment) => payment.pid > (lastPid || 0));
  
//     if (newPayments.length > 0) {
//       return res.status(200).json({
//         code: 2000,
//         data: {
//           payments: newPayments,
//         },
//       });
//     } else {
//       return res.status(404).json({ code: 1000, message: 'No more payments' });
//     }
//   });


// let payments = [];

// app.post('/payment/create', (req, res) => {
//   const { pid, name, amount, date, vpa } = req.body;

//   // Validate required fields
//   if (!pid || !name || !amount || !date || !vpa) {
//     return res.status(400).json({ code: 4000, message: 'Missing required parameters' });
//   }

//   // Create a new payment object with dynamic vpa
//   const newPayment = {
//     pid,
//     name,
//     amount,
//     date,
//     vpa, // Add vpa dynamically from the request body
//   };

//   // Add the new payment to the payments array
//   payments.push(newPayment);

//   return res.status(200).json({
//     code: 2000,
//     message: 'Payment created successfully',
//     data: newPayment,
//   });
// });

// app.post('/payment/get',checkAccessToken, (req, res) => {
//     const { uuid, vpa, date, lastPid, limit = 10 } = req.body;
  
//     // Validate required fields
//     if (!uuid || !vpa || !date) {
//       return res.status(400).json({ code: 4000, message: 'Missing required parameters' });
//     }
  
//     // Get today's date in YYYY-MM-DD format (UTC)
//     const today = new Date().toISOString().split('T')[0];
  
//     // Filter payments for today's date
//     const filteredPayments = payments.filter((payment) => {
//       const paymentDate = new Date(payment.date).toISOString().split('T')[0];
//       return paymentDate === today;
//     //   return paymentDate === today && payment.vpa === vpa;
//     });
  
//     // Filter payments after lastPid
//     const newPayments = filteredPayments
//       .filter((payment) => payment.pid > (lastPid || 0))
//       .slice(0, limit); // Apply limit to the number of payments returned
  
//       if (uuid === '123payBankIbr' && vpa === 'ABC Provisions') 
        
        
//     if (newPayments.length > 0) {
//       return res.status(200).json({
//         code: 2000,
//         data: {
//           payments: newPayments,
//         },
//       });
//     } else {
//       return res.status(404).json({ code: 1000, message: 'No more payments' });
//     }
//   });

app.post('/payment/get', checkAccessToken, (req, res) => {
  const { uuid, vpa, date, lastPid, limit = 10 } = req.body;

  // Validate required fields
  if (!uuid || !vpa || !date) {
    return res.status(400).json({ code: 4000, message: 'Missing required parameters' });
  }

  // Get today's date in YYYY-MM-DD format (UTC)
  const today = new Date().toISOString().split('T')[0];

  // Filter payments for today's date
  const filteredPayments = payments.filter((payment) => {
    const paymentDate = new Date(payment.date).toISOString().split('T')[0];
    return paymentDate === today;
  });

  // Filter payments after lastPid
  const newPayments = filteredPayments
    .filter((payment) => payment.pid > (lastPid || 0))
    .slice(0, limit); // Apply limit to the number of payments returned

  if (uuid === '123payBankIbr' && vpa === 'ABC Provisions') {
    if (newPayments.length > 0) {
      return res.status(200).json({
        code: 2000,
        data: {
          payments: newPayments,
        },
      });
    } else {
      return res.status(404).json({ code: 1000, message: 'No more payments' });
    }
  } else {
    return res.status(404).json({ code: 1000, message: 'No record found' });
  }
});
// Endpoint to fetch payment summary
// app.post('/payment/summary/get', (req, res) => {
//   const { uuid, vpa, date } = req.body;

//   if (!uuid || !vpa || !date) {
//     return res.status(400).json({ code: 4000, message: 'Missing required parameters' });
//   }

//   // Calculate total amount and transaction count dynamically
//   const totalAmount = payments.reduce((sum, payment) => sum + payment.amount, 0);
//   const transactionCount = payments.length;

//   if (uuid === '12345' && vpa === 'test@upi') {
//     return res.status(200).json({
//       code: 2000,
//       data: {
//         totalAmount: totalAmount,
//         transactionCount: transactionCount,
//       },
//     });
//   }

//   return res.status(404).json({ code: 1000, message: 'No record found' });
// });
// app.post('/payment/summary/get',checkAccessToken, (req, res) => {
//     const { uuid, vpa, date } = req.body;
  
//     // Validate required fields
//     if (!uuid || !vpa || !date) {
//       return res.status(400).json({ code: 4000, message: 'Missing required parameters' });
//     }
  
//     // Get today's date in YYYY-MM-DD format (UTC)
//     const today = new Date().toISOString().split('T')[0];
  
//     // Filter payments for today's date
//     const filteredPayments = payments.filter((payment) => {
//       const paymentDate = new Date(payment.date).toISOString().split('T')[0];
//       return paymentDate === today;
//     });
  
//     // Calculate total amount and transaction count
//     const totalAmount = filteredPayments.reduce((sum, payment) => sum + payment.amount, 0);
//     const transactionCount = filteredPayments.length;
  
//     if (uuid === '123payBankIbr' && vpa === 'ABC Provisions') {
//       return res.status(200).json({
//         code: 2000,
//         data: {
//           totalAmount: totalAmount,
//           transactionCount: transactionCount,
//         },
//       });
//     }
  
//     return res.status(404).json({ code: 1000, message: 'No record found' });
//   });
app.post('/payment/summary/get', checkAccessToken, (req, res) => {
  const { uuid, vpa, date } = req.body;

  // Validate required fields
  if (!uuid || !vpa || !date) {
    return res.status(400).json({ code: 4000, message: 'Missing required parameters' });
  }

  // Get today's date in YYYY-MM-DD format (UTC)
  const today = new Date().toISOString().split('T')[0];

  // Filter payments for today's date
  const filteredPayments = payments.filter((payment) => {
    const paymentDate = new Date(payment.date).toISOString().split('T')[0];
    return paymentDate === today;
  });

  // Calculate total amount and transaction count
  const totalAmount = filteredPayments.reduce((sum, payment) => sum + payment.amount, 0);
  const transactionCount = filteredPayments.length;

  if (uuid === '123payBankIbr' && vpa === 'ABC Provisions') {
    return res.status(200).json({
      code: 2000,
      data: {
        totalAmount: totalAmount,
        transactionCount: transactionCount,
      },
    });
  }

  return res.status(404).json({ code: 1000, message: 'No record found' });
});


// Start the server
app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});
