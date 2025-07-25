Describe "AzureConfig" -Tag "Backup", "Azure" {
    It "MT.1065: Ensure all Recovery Services Vaults have soft delete enabled" {

        $result = Test-MtVaultSoftDelete

        $result | Should -Be $true -Because "Vaults must be protected from accidental deletion"
    }
}
