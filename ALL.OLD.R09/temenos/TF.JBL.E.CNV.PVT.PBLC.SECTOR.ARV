SUBROUTINE TF.JBL.E.CNV.PVT.PBLC.SECTOR.ARV
*-----------------------------------------------------------------------------
*Subroutine Description:
*Subroutine Type:
*Attached To    : JBL.ENQ.JBL.ARV
*Attached As    : CONVERSION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 29/12/2019 -                            CREATE   - SHAJJAD HOSSEN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ENQUIRY.SELECT
    $INSERT I_GTS.COMMON
    
    $USING EB.Reports
    
    Y.TYPE = EB.Reports.getOData()
    IF Y.TYPE EQ 'PUBLIC' THEN
        Y.RETURN = "1"
    END ELSE
        Y.RETURN = "2"
    END
    EB.Reports.setOData(Y.RETURN)
RETURN

END
