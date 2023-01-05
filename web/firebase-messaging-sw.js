importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyC-ABb-5SHB7-S7-sD__KF2uYGCnRkrLDk",
  authDomain: "cp-smart-building-dev.firebaseapp.com",
  projectId: "cp-smart-building-dev",
  storageBucket: "cp-smart-building-dev.appspot.com",
  messagingSenderId: "898842009983",
  appId: "1:898842009983:web:d1b34f85d50d7624ea3a4a",
  measurementId: "G-262YJGBYY9"
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});
