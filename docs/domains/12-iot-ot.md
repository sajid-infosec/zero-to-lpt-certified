# Domain 12 · IoT & OT Penetration Testing

> Module 13. Embedded devices and industrial systems. CPENT tests firmware analysis and ICS/SCADA protocol understanding — areas most testers never touch.

## Why it matters

IoT/OT devices run the physical world (sensors, PLCs, cameras, routers) and are notoriously insecure: hard-coded credentials, unsigned firmware, plaintext protocols. The exam includes firmware images to analyze and SCADA traffic (Modbus) to interpret.

---

## Part A — IoT firmware analysis

### Concepts
- Firmware images bundle a **bootloader**, **kernel**, and a compressed **root filesystem** (often SquashFS/CramFS, LZMA/gzip).
- **uImage header** (magic `0x27051956`) holds timestamp, CRC, load address, and the original (gzipped) kernel name — conventionally **`piggy`**.
- The prize is usually **hard-coded credentials**, private keys, or backdoors in the extracted filesystem.

### Workflow
1. **Identify:** `file image.bin`; `binwalk image.bin` to map sections/signatures (compression, FS, headers).
2. **Extract:** `binwalk -e image.bin` (auto-carve) or `dd` at a reported offset; `unsquashfs` for SquashFS.
3. **Inspect:** read header fields (year/CRC/loader offset, inode count from the FS superblock).
4. **Hunt secrets:** `grep -rniE 'passw|admin|key|token' ./_image.bin.extracted`.
5. **Deeper RE:** load device binaries in **Ghidra**; emulate with **QEMU**/**firmadyne**/**FAT** (Firmware Analysis Toolkit) to interact with the device's web UI.

### Commands
```bash
file FileOne.bin
binwalk FileOne.bin                 # signature map (LZMA, SquashFS, uImage…)
binwalk -e FileOne.bin              # extract
unsquashfs -s squashfs-root.bin     # superblock (inodes, compression)
grep -rniE 'web_passwd|password|admin' _FileOne.bin.extracted/
strings -n 8 firmware.bin | grep -i pass
```

### Tools
| Tool | Purpose |
|---|---|
| **binwalk** | identify + extract embedded data |
| **firmware-mod-kit / unsquashfs** | manual FS extraction |
| **Ghidra** | RE extracted binaries |
| **QEMU / firmadyne / FAT** | emulate firmware to interact |
| **strings / grep** | credential hunting |

---

## Part B — OT / ICS / SCADA

### Concepts
- **OT** = operational technology controlling physical processes; **ICS/SCADA** supervise it.
- **Modbus/TCP** is the classic protocol — **no auth, no encryption**. MBAP header: **Transaction ID**, **Protocol ID (always 0)**, **Length**, **Unit ID**, then function code + data. Registers are 16-bit (UINT16), read in hex.
- Other protocols: DNP3, S7comm, EtherNet/IP, Profinet, BACnet.
- **Safety first:** OT devices are fragile and control physical equipment. In real engagements you are extremely cautious; on the range you mostly *analyze captured traffic* (PCAPs) rather than fuzz live PLCs.

### Workflow (traffic analysis)
1. Obtain the capture (often after compromising an OT jump host).
2. Open in **Wireshark**; filter `modbus`.
3. Follow transactions by ID; read MBAP and PDU fields (function code, register address/value).
4. Map a device MAC's **OUI** (first 3 bytes) to a vendor.
5. Understand which registers map to which physical readings/setpoints (impact analysis).

### Commands
```bash
# Wireshark display filters
modbus
modbus.trans_id == 209
tcp.port == 502 && modbus
# Live discovery (CAUTION on production OT)
nmap --script modbus-discover -p 502 <plc>
```

### Tools
| Tool | Purpose |
|---|---|
| **Wireshark / tshark** | dissect Modbus/ICS traffic |
| **Nmap ICS NSE** (`modbus-discover`, `s7-info`) | careful live discovery |
| **plcscan / Redpoint** | ICS device discovery |
| **conpot** | ICS honeypot for safe practice |

## Common pitfalls

- IoT: stopping at the first plaintext `password=` string instead of grepping the whole FS; carving the wrong embedded FS.
- OT: treating it like IT — aggressive scanning can disrupt physical processes. Read traffic; don't fuzz production.
- Confusing request vs response packets when reading register values.

## Exam relevance

Expect to extract a firmware image and recover credentials, and to read Modbus fields from a PCAP (transaction IDs, protocol ID, register values, vendor OUI, MAC formatting). Precision and Wireshark fluency are what's tested.

## MITRE / mapping

- ATT&CK for **ICS** (separate matrix); IT-side `T1040` (Network Sniffing), `T1592` (Host Info), `T1552.001` (Creds in Files).

## Practice

- Extract router firmware (e.g., DD-WRT/OpenWrt images) with binwalk; recover configs.
- Analyze public SCADA/Modbus PCAPs in Wireshark; stand up **conpot** to generate safe traffic.

## Self-check

- [ ] I can carve a firmware image and recover hard-coded creds.
- [ ] I can read any Modbus field from a PCAP and resolve a vendor OUI.
- [ ] I understand why OT requires extreme caution vs. IT targets.
