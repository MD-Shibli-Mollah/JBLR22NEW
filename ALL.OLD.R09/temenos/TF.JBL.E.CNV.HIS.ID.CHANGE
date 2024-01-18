SUBROUTINE TF.JBL.E.CNV.HIS.ID.CHANGE
*-----------------------------------------------------------------------------
*Subroutine Description: Change history file record id for other template record id
*Subroutine Type:
*Attached To    : JBL.ENQ.HIS.LC
*Attached As    : CONVERSION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 18/03/2020 -                            CREATE   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING EB.Reports
    
    Y.ID = EB.Reports.getOData()
    Y.ID.1 = FIELD(Y.ID,';',1)
    Y.ID.2 = FIELD(Y.ID,';',2)
    NEW.ID = Y.ID.1:"-":Y.ID.2
    
    EB.Reports.setOData(NEW.ID)
END
