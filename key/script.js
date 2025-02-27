// Function to generate a unique persistent key
function generateKey() {
    const deviceInfo = navigator.userAgent; // Device + browser info
    const date = new Date().toISOString().split("T")[0]; // YYYY-MM-DD
    const rawKey = btoa(deviceInfo + date).slice(0, 16); // Base64 + slice

    localStorage.setItem("key", rawKey);
    localStorage.setItem("keyDate", date);

    return rawKey;
}

function getKey() {
    const storedKey = localStorage.getItem("key");
    const storedDate = localStorage.getItem("keyDate");
    const today = new Date().toISOString().split("T")[0];

    if (storedKey && storedDate === today) {
        return storedKey;
    }
    return generateKey();
}

document.write(getKey()); // Show raw text only
