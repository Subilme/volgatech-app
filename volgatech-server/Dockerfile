FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["volgatech-server.csproj", ""]
RUN dotnet restore "volgatech-server.csproj"
COPY . .
WORKDIR "/src"
RUN dotnet build "volgatech-server.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "volgatech-server.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "volgatech-server.dll"]