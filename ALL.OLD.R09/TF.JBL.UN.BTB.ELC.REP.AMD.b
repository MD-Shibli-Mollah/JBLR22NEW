* @ValidationCode : MjoxMzExOTAyODQwOkNwMTI1MjoxNTc0MTYxNzEwMjQxOkRFTEw6LTE6LTE6MDowOmZhbHNlOk4vQTpSMTdfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Nov 2019 17:08:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : DELL
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R17_AMR.0
SUBROUTINE TF.JBL.UN.BTB.ELC.REP.AMD
*-----------------------------------------------------------------------------
* This routine is use to update Contract field 'SCT.CONTRACT.AVAIL.AMT'
* and 'SCT.CONTRACT.AMT.NAU' after COMMIT the Transaction. This routine is
* called while committing a new record or existing record ater making the
* necessary changes. it is called after the version Inpur Routine. at this
* stage the record would have been written into the $NAU file.
*-----------------------------------------------------------------------------
* Modification History : Abu Huraira
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BD.SCT.CAPTURE
*-----------------------------------------------------------------------------
    $USING LC.Contract
    $USING EB.DataAccess
    $USING EB.Foundation
    $USING EB.SystemTables
    $USING EB.ErrorProcessing

    IF V$FUNCTION EQ 'I' THEN
        GOSUB INIT
        GOSUB OPENFILES
        GOSUB PROCESS
    END
RETURN
*****
INIT:
*****
    FN.LC = 'F.LETTER.OF.CREDIT'; F.LC = ''
    FN.SCT = 'F.BD.SCT.CAPTURE'; F.SCT = ''

    APP.NAME = 'LETTER.OF.CREDIT'
    LOCAL.FIELDS = 'LT.TF.SCONT.ID':VM:'LT.TF.CONT.RAMT'
    
    EB.Foundation.MapLocalFields(APP.NAME, LOCAL.FIELDS, FLD.POS)
    Y.TF.SCONT.ID.POS = FLD.POS<1,1>
    Y.TF.CONT.RAMT.POS = FLD.POS<1,2>
RETURN
**********
OPENFILES:
**********
    EB.DataAccess.Opf(FN.LC,F.LC)
    EB.DataAccess.Opf(FN.SCT,F.SCT)
RETURN
********
PROCESS:
********
* LC Operation type not allowed other than 'A'
    Y.LC.OPERATION = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcOperation)
    IF Y.LC.OPERATION NE 'A' THEN
        EB.SystemTables.setEtext('LC Operation Type Must be A')
        EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcOperation)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
   
* find RNew and RNewLast Local reference field value for current LC
    Y.LC.LOC.REF= EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
    Y.LC.LOC.REF.RNEW.LST = EB.SystemTables.getRNewLast(LC.Contract.LetterOfCredit.TfLcLocalRef)
    Y.LC.LOC.REF.ROLD.LST = EB.SystemTables.getROld(LC.Contract.LetterOfCredit.TfLcLocalRef)
    Y.LC.REC.STATUS = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcRecordStatus)

* process calculation for every sales contract entered in LC
    Y.SCT.ID.LST = Y.LC.LOC.REF<1,Y.TF.SCONT.ID.POS>
    Y.SCT.ID.CNT = DCOUNT(Y.LC.LOC.REF<1,Y.TF.SCONT.ID.POS>,SM)
    FOR I = 1 TO Y.SCT.ID.CNT
        Y.TF.SCONT.ID = FIELD(Y.SCT.ID.LST,SM,I)
        EB.DataAccess.FRead(FN.SCT,Y.TF.SCONT.ID,R.SCT.REC,F.SCT,SCT.ERR)
        Y.SCT.CONT.AMT.NAU = R.SCT.REC<SCT.CONTRACT.AMT.NAU>
        Y.SCT.AVAIL.AMT = R.SCT.REC<SCT.CONTRACT.AVAIL.AMT>
        
        Y.TF.CONT.RAMT.RNEW.LAST = Y.LC.LOC.REF.RNEW.LST<1,Y.TF.CONT.RAMT.POS,I>
        Y.TF.CONT.RAMT.ROLD = Y.LC.LOC.REF.ROLD.LST<1,Y.TF.CONT.RAMT.POS,I>
        Y.TF.CONT.RAMT.NEW = Y.LC.LOC.REF<1,Y.TF.CONT.RAMT.POS,I>
* update Sales Contract record if changes amendment done on any ELC record
        IF Y.LC.REC.STATUS EQ 'INAU' AND Y.TF.CONT.RAMT.RNEW.LAST NE "" AND Y.TF.CONT.RAMT.RNEW.LAST NE "0" THEN
            R.SCT.REC<SCT.CONTRACT.AVAIL.AMT> = Y.SCT.AVAIL.AMT - (Y.TF.CONT.RAMT.NEW - Y.TF.CONT.RAMT.RNEW.LAST)
            R.SCT.REC<SCT.CONTRACT.AMT.NAU> = Y.SCT.CONT.AMT.NAU + (Y.TF.CONT.RAMT.NEW - Y.TF.CONT.RAMT.RNEW.LAST)
            WRITE R.SCT.REC ON F.SCT,Y.TF.SCONT.ID
        END ELSE
            R.SCT.REC<SCT.CONTRACT.AVAIL.AMT> = Y.SCT.AVAIL.AMT - (Y.TF.CONT.RAMT.NEW - Y.TF.CONT.RAMT.ROLD)
            R.SCT.REC<SCT.CONTRACT.AMT.NAU> = Y.SCT.CONT.AMT.NAU + (Y.TF.CONT.RAMT.NEW - Y.TF.CONT.RAMT.ROLD)
            WRITE R.SCT.REC ON F.SCT,Y.TF.SCONT.ID
        END
    NEXT I
RETURN
END
