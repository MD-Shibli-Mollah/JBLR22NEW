SUBROUTINE TF.JBL.I.CHK.EXP.COLL.DOC
*-----------------------------------------------------------------------------
*Subroutine Description: Check export LC FOREIGN or not
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT Version (DRAWINGS,TF.JBL.F.EXPCOLL)
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 22/10/2019 -                            Retrofit   - MD.KAMRUL HASAN
*                                                 FDS Pvt Ltd
*-----------------------------------------------------------------------------
    $INCLUDE  I_COMMON
    $INCLUDE  I_EQUATE
    
*$INCLUDE JBL.BP I_F.BD.EXPFORM.REGISTER

    $USING LC.Contract
    $USING LC.Config
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.LocalReferences
    $USING EB.Updates
    $USING EB.ErrorProcessing
*-----------------------------------------------------------------------------
    GOSUB INITIALISE; *INITIALISATION
    GOSUB PROCESS; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------
RETURN


*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
***********

    FN.LC = 'F.LETTER.OF.CREDIT'
    F.LC = ''
    EB.DataAccess.Opf(FN.LC,F.LC)
    R.LC.REC = ''
    Y.LC.ERR = ''

    FN.DR = 'F.DRAWINGS'
    F.DR = ''
    EB.DataAccess.Opf(FN.DR,F.DR)
    R.DR.REC = ''
    Y.DR.ERR = ''

    FN.EXPFORM = 'F.BD.EXPFORM.REGISTER'
    F.EXPFORM = ''
    EB.DataAccess.Opf(FN.EXPFORM,F.EXPFORM)
    R.EXPFORM.REC = ''
    Y.EXPFORM.ERR = ''

    FN.LC.TYPES = 'F.LC.TYPES'
    F.LC.TYPES = ''
    EB.DataAccess.Opf(FN.LC.TYPES,F.LC.TYPES)
    R.LC.TYPES.REC = ''
    Y.LC.TYPES.ERR = ''

    Y.DR.ID = ''
    Y.TF.ID = ''
    Y.EXPFORM.NO = ''
    Y.LC.TYPE.LF = ''
    Y.LC.OSTAMT = ''
    Y.DOC.AMT = ''

RETURN
*-----------------------------------------------------------------------------
PROCESS:
********
    GOSUB GET.LOC.REF.POS
    Y.EXPFORM.NO = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.DR.EXPNO.POS>
    Y.DR.ID =  EB.SystemTables.getIdNew()
    Y.TF.ID = Y.DR.ID[1,12]
    EB.DataAccess.FRead(FN.LC,Y.TF.ID,R.LC.REC,F.LC,Y.LC.ERR)
    Y.LC.TYPES = R.LC.REC< LC.Contract.LetterOfCredit.TfLcLcType>
    EB.DataAccess.FRead(FN.LC.TYPES,Y.LC.TYPES,R.LC.TYPES.REC,F.LC.TYPES,Y.LC.TYPES.ERR)
    Y.LC.TYPE.LF = R.LC.TYPES.REC<LC.Config.Types.TypLocalRef ,Y.LCTYP.LF.POS>
    IF Y.LC.TYPE.LF EQ "FOREIGN" AND Y.EXPFORM.NO EQ "" THEN
        EB.SystemTables.setAf(LC.Contract.Drawings.TfDrLocalRef)
        EB.SystemTables.setAv(Y.DR.EXPNO.POS)
        EB.SystemTables.setEtext("EXP Number Mandatory for Foreign LCs")
        EB.ErrorProcessing.StoreEndError()
    END ELSE

    END
    Y.LC.OSTAMT = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.DR.LCOSAMT.POS>
    Y.DOC.AMT = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDocumentAmount)
    IF Y.DOC.AMT GT Y.LC.OSTAMT THEN
        EB.SystemTables.setAf(TF.DR.DOCUMENT.AMOUNT)
        EB.SystemTables.setEtext("Doc Amount>Oustanding Amount")
       
        EB.ErrorProcessing.StoreEndError()
    END

RETURN


GET.LOC.REF.POS:
*--------------
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.LC.OUSAMT",Y.DR.LCOSAMT.POS)
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.EXP.FM.NO",Y.DR.EXPNO.POS)
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.DOC.TYPE",Y.DR.DOCTYPE.POS)
    EB.LocalReferences.GetLocRef("LC.TYPES","LT.LCTP.LOC.FRG",Y.LCTYP.LF.POS)

RETURN
END
