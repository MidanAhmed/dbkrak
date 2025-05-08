import { Command } from 'commander';
import { introspectSchemas } from '../db/introspect';
import { diffSchemas } from '../db/compare';
import { generateSQL } from '../db/generateSQL';
import { log } from '../utils/logger';

export function registerMigrateCommand(program: Command) {
    program
        .command('migrate')
        .description('Generate migration SQL to sync schemas')
        .requiredOption('--from <url>', 'Source DB')
        .requiredOption('--to <url>', 'Target DB')
        .action(async (options) => {
            const [fromSchema, toSchema] = await introspectSchemas(options.from, options.to);
            const diffs = diffSchemas(fromSchema, toSchema);
            const sql = generateSQL(diffs);
            log(sql);
        });
}