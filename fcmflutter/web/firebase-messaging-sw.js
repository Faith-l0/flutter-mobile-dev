importScripts("https://www.gstatic.com/firebasejs/10.12.2/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.12.2/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyBBX0ektk381HNaL5E58gmzwQ34fdrdFpU",
  authDomain: "fcmflutter-3c0e2.firebaseapp.com",
  projectId: "fcmflutter-3c0e2",
  storageBucket: "fcmflutter-3c0e2.firebasestorage.app",
  messagingSenderId: "1079452648976",
  appId: "1:1079452648976:web:6fe9f35b8594b2b8ab2c95",
});

const messaging = firebase.messaging();
