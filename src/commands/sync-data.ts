import { Command } from 'commander';
import { syncData } from '../db/transfer';
import { log } from '../utils/logger';

export function registerSyncDataCommand(program: Command) {
    program
        .command('sync-data')
        .description('Copy data from source to target')
        .requiredOption('--from <url>', 'Source DB')
        .requiredOption('--to <url>', 'Target DB')
        .action(async (options) => {
            await syncData(options.from, options.to);
            log('Data sync complete');
        });
}