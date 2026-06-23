# iOS App 客户签发说明

本文档用于说明如何对交付的未签名 iOS App 进行企业签名、生成 `.ipa`，并通过客户自有 MDM/签发平台分发。

## 交付物说明

本次交付物包含：

```text
jtydmhapp-unsigned.xcarchive.zip
jtydmhapp-unsigned.app.zip
jtydmh-ios_1_artifacts.zip
```

推荐优先使用：

```text
jtydmhapp-unsigned.xcarchive.zip
```

`jtydmhapp-unsigned.app.zip` 可作为重签备选。`jtydmh-ios_1_artifacts.zip` 通常包含构建日志、entitlements 等辅助文件。

交付物不包含源代码。

## App 信息

主 App：

```text
Bundle ID: com.eccl.jtmh
App path: jtydmhapp.app
```

Network Extension：

```text
Bundle ID: com.eccl.jtmh.PacketTunnel
Extension path: jtydmhapp.app/PlugIns/PacketTunnel.appex
```

签发时必须同时签名主 App 和 `PacketTunnel.appex`。

## 客户侧签发材料

客户签发环境需要准备：

```text
Apple 企业开发者账号或客户自有 iOS 企业签发能力
iOS Distribution / In-House 证书
com.eccl.jtmh 对应的 In-House provisioning profile
com.eccl.jtmh.PacketTunnel 对应的 In-House provisioning profile
```

主 App 和扩展使用的证书、Team ID、App Groups、Network Extension 权限必须一致且匹配。

## 必须匹配的能力

请确认 Apple Developer 后台、provisioning profile 和最终签名 entitlements 至少覆盖以下能力：

```text
Network Extension / packet-tunnel-provider
App Groups: group.com.eccl.jtmh
WiFi Info
Push Notifications，如客户环境要求启用
iCloud container: iCloud.iCloud-jtmh，如保留当前 release entitlement
```

如客户侧无法使用 `com.eccl.jtmh` 或 `com.eccl.jtmh.PacketTunnel`，请不要直接修改二进制包内 Bundle ID，建议通知交付方按客户指定 Bundle ID 重新编译未签名包。

## 推荐签发流程

1. 解压 `jtydmhapp-unsigned.xcarchive.zip`。
2. 从 archive 中取得 App：

```text
jtydmhapp.xcarchive/Products/Applications/jtydmhapp.app
```

3. 将客户的 provisioning profile 嵌入对应位置：

```text
jtydmhapp.app/embedded.mobileprovision
jtydmhapp.app/PlugIns/PacketTunnel.appex/embedded.mobileprovision
```

4. 先签名扩展：

```text
jtydmhapp.app/PlugIns/PacketTunnel.appex
```

5. 再签名主 App：

```text
jtydmhapp.app
```

6. 将签名后的 `jtydmhapp.app` 放入 `Payload/` 目录，并压缩为 `.ipa`：

```text
Payload/jtydmhapp.app
jtydmhapp-enterprise.ipa
```

7. 通过客户自有 MDM/企业分发平台发布 `.ipa`。

## 命令行签名参考

以下命令仅作为手工重签参考，客户如已有签发平台，应以客户平台流程为准。

```bash
unzip jtydmhapp-unsigned.xcarchive.zip

APP="jtydmhapp.xcarchive/Products/Applications/jtydmhapp.app"
EXT="$APP/PlugIns/PacketTunnel.appex"

MAIN_PROFILE="com.eccl.jtmh.mobileprovision"
EXT_PROFILE="com.eccl.jtmh.PacketTunnel.mobileprovision"
IDENTITY="Apple Distribution: 客户公司名称 (TEAMID)"

cp "$MAIN_PROFILE" "$APP/embedded.mobileprovision"
cp "$EXT_PROFILE" "$EXT/embedded.mobileprovision"

security cms -D -i "$MAIN_PROFILE" > main-profile.plist
security cms -D -i "$EXT_PROFILE" > extension-profile.plist

/usr/libexec/PlistBuddy -x -c 'Print :Entitlements' main-profile.plist > main.entitlements
/usr/libexec/PlistBuddy -x -c 'Print :Entitlements' extension-profile.plist > extension.entitlements

codesign -f -s "$IDENTITY" --entitlements extension.entitlements "$EXT"
codesign -f -s "$IDENTITY" --entitlements main.entitlements "$APP"

codesign --verify --deep --strict --verbose=2 "$APP"

rm -rf Payload
mkdir Payload
cp -R "$APP" Payload/
ditto -c -k --keepParent Payload jtydmhapp-enterprise.ipa
```

## 验收检查

签发完成后建议至少检查：

```text
IPA 可通过 MDM 安装到真实 iPhone
主 App 可启动
PacketTunnel/VPN 能正常启动和停止
App Groups 数据访问正常
网络访问、推送、文件、相册、WebView 等业务权限正常
不同 iOS 版本的兼容性
```

## 常见问题

如果提示 profile 不匹配，请检查：

```text
主 App profile 是否对应 com.eccl.jtmh
扩展 profile 是否对应 com.eccl.jtmh.PacketTunnel
profile 类型是否为 In-House/Enterprise
profile 是否包含当前使用的 Distribution 证书
profile 是否包含 Network Extension 和 App Groups 权限
```

如果提示 extension 安装失败，请重点检查 `PacketTunnel.appex` 是否单独签名，以及扩展 profile 是否正确。

如果客户需要改 Bundle ID、Team ID、App Group 或 iCloud container，建议由交付方重新编译未签名包后再交付签发。
