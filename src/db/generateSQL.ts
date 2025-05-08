export function generateSQL(diffs: string[]) {
    // mock implementation
    return diffs.map(diff => `-- SQL for: ${diff}`).join('\n');
}