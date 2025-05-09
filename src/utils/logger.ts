export function log(message: string) {
    if (Array.isArray(message)) {
        message.forEach(m => console.log(m));
    } else {
        console.log(message);
    }
}