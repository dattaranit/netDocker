FROM mcr.microsoft.com/dotnet/core/aspnet:2.2 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build
WORKDIR /src
COPY ["ngNetDocker.csproj", "./"]
RUN dotnet restore "./ngNetDocker.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "ngNetDocker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ngNetDocker.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ngNetDocker.dll"]
