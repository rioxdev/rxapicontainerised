# See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

# Multi-stage Dockerfile for a single-project repo with the project in rxapicontainerised/
# This version works whether you build with the repo root as context or from the rxapicontainerised folder.
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Copy the full build context (robust for different build contexts)
COPY . .

# Set working directory to the project folder and restore/build/publish
WORKDIR /src/rxapicontainerised
RUN dotnet restore "rxapicontainerised.csproj"
RUN dotnet build "rxapicontainerised.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
WORKDIR /src/rxapicontainerised
RUN dotnet publish "rxapicontainerised.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "rxapicontainerised.dll"]