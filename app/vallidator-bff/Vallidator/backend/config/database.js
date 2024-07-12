// Em /config/database.js
import pg from 'pg';

//abre as informações do banco em /config/config.json
import config from '/config/config.json' assert { type: "json" }; 

//cria um pool de conexões
const pool = new pg.Pool(config);


export default pool;
