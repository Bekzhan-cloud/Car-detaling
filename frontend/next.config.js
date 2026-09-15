/** @type {import('next').NextConfig} */
const repoName = process.env.NEXT_PUBLIC_REPO_NAME || "";
const isStaticExport = process.env.NEXT_OUTPUT === "export";

const nextConfig = {
  output: isStaticExport ? "export" : "standalone",
  ...(repoName
    ? {
        basePath: `/${repoName}`,
        assetPrefix: `/${repoName}/`
      }
    : {}),
  trailingSlash: true,
  images: {
    unoptimized: isStaticExport,
    remotePatterns: [
      {
        protocol: "https",
        hostname: "images.unsplash.com"
      },
      {
        protocol: "https",
        hostname: "res.cloudinary.com"
      }
    ]
  }
};

module.exports = nextConfig;
