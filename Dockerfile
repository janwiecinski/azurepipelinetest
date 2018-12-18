FROM microsoft/dotnet:sdk AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY AzurePipelineTest/*.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY AzurePipelineTest/. ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM microsoft/dotnet:aspnetcore-runtime
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "azurepipelinetest.dll"]