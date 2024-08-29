struct BluetoothStatusChanged: Decodable {
    let isBluetoothOn: Bool?
    let bluetoothPermissionSetting: String?
    let isBluetoothRestarting: Bool?
}
