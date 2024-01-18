SUBROUTINE TF.JBL.CNV.BRANCH.CODE
*-----------------------------------------------------------------------------
*Subroutine Description: Branch ID to branch code generation
*Attached To    : enquiry JBL.ENQ.H.DD.BR.NAME
*Attached As    : Conversion routine ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 05/05/2021 -                            CREATE   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING EB.Reports
    
    Y.COM.ID = EB.Reports.getOData()
    Y.REF = Y.COM.ID[6,4]
    EB.Reports.setOData(Y.REF)
END
 