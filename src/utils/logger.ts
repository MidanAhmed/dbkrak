export function log(message: any) {
    if (Array.isArray(message)) {
        message.forEach(m => console.log(m));
    } else {
        console.log(message);
    }
}