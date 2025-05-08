import { Command } from 'commander';
import { introspectSchemas } from '../db/introspect';
import { diffSchemas } from '../db/compare';
import { log } from '../utils/logger';

export function registerDiffCommand(program: Command) {
    program
        .command('diff')
        .description('Compare two PostgreSQL schemas')
        .requiredOption('--source <url>', 'Source DB connection URL')
        .requiredOption('--target <url>', 'Target DB connection URL')
        .action(async (options) => {
            const [sourceSchema, targetSchema] = await introspectSchemas(options.source, options.target);
            const diffs = diffSchemas(sourceSchema, targetSchema);
            log(diffs);
        });
}