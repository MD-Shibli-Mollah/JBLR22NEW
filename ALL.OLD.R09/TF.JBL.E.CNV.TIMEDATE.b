SUBROUTINE TF.JBL.E.CNV.TIMEDATE
*-----------------------------------------------------------------------------
*Subroutine Description: Change history file record id for other template record id
*Subroutine Type:
*Attached To    : BD.CATEG.ENT.BOOK
*Attached As    : CONVERSION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 18/09/2020 -                            CREATE   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING EB.Reports
    
    EB.Reports.setOData(TIMEDATE())
END
