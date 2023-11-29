#!/bin/bash
dotnet ef dbcontext scaffold --force \
"Host=localhost;Database=fasteignaskra;Username=fasteignaskra;Password=fasteignaskra" Npgsql.EntityFrameworkCore.PostgreSQL \
--data-annotations \
--output-dir EF \
--namespace FasteignirCommon.EF \
--context-dir EF \
--no-onconfiguring \
--context-namespace FasteignirCommon.EF 


