import { cpSync, mkdirSync, writeFileSync } from 'node:fs';
import { resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { buildDossier } from './vendor/makefun-roblox.ts';

const root = fileURLToPath(new URL('.', import.meta.url));
const out = resolve(process.env.MAKEFUN_OUTPUT_DIR || '/output');
mkdirSync(out, { recursive: true });
for (const name of ['game.rbxl', 'PLAY.json']) cpSync(resolve(root, name), resolve(out, name));
for (const name of ['src', 'screenshots']) cpSync(resolve(root, name), resolve(out, name), { recursive: true, filter: (source) => !source.split('/').pop()?.startsWith('.') });
const limits = { text_max_bytes: 65536, screenshots: { max: 4, max_bytes: 262144 }, max_instances: 500000, scripts_max_source_bytes: 8388608, scripts_max_path_chars: 1048576 };
writeFileSync(resolve(out, 'dossier.json'), buildDossier(out, limits));
