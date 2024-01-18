SUBROUTINE TF.JBL.V.CANCEL.MSG.POPU
*-----------------------------------------------------------------------------
*Subroutine Description: Customer Details Auto Population
*Attached To    : LETTER.OF.CREDIT Version (EB.QUERIES.ANSWERS,JBL.CANCEL)
*Attached As    : VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 22/03/2021 -                            Retrofit   - SHAJJAD HOSSEN
*                                                 FDS Ltd
*-----------------------------------------------------------------------------

 
    $INCLUDE  I_COMMON
    $INCLUDE  I_EQUATE
    
    $USING LC.Contract
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.LocalReferences
    $USING EB.TransactionControl
    $USING DE.Config
    $USING DE.Messaging
    $USING EB.Updates
    $USING FT.Contract

*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
    
INITIALISE:
    FN.DEL = 'F.DE.O.HEADER'
    F.DEL = ''
    
    FN.LC = 'F.LETTER.OF.CREDIT'
    F.LC = ''
    
    FN.DR = 'F.DRAWINGS'
    F.DR = ''
    
    FN.EB = 'F.EB.QUERIES.ANSWERS'
    F.EB = ''
    
    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT = ''
    
    FLD.POS = ''
*    APPLICATION.NAME = 'DRAWINGS':FM:'EB.QUERIES.ANSWERS'
*    LOCAL.FIELD = 'LT.TF.ELC.COLNO':FM:'LT.TF.TRNS.REF'

    FLD.POS = ''
*    APPLICATION.NAME = 'DRAWINGS':FM:'EB.QUERIES.ANSWERS'
*    LOCAL.FIELD = 'LT.TF.ELC.COLNO':VM:'LT.TFDR.LC.NO':FM:'LT.TF.TRNS.REF'
    APPLICATION.NAME = 'DRAWINGS'
    LOCAL.FIELD = 'LT.TF.ELC.COLNO':VM:'LT.TFDR.LC.NO'
    EB.Updates.MultiGetLocRef(APPLICATION.NAME,LOCAL.FIELD,FLD.POS)
    Y.DR.COL.POS = FLD.POS<1,1>
    Y.TFDR.NO.POS = FLD.POS<1,2>
*    Y.TRANS.REF.POS = FLD.POS<2,1>
    Y.TRANS.REF = ''
    
    
RETURN
OPENFILE:
    EB.DataAccess.Opf(FN.DEL, F.DEL)
    EB.DataAccess.Opf(FN.LC, F.LC)
    EB.DataAccess.Opf(FN.DR, F.DR)
    EB.DataAccess.Opf(FN.EB, F.EB)
    
    Y.DEL.ID = EB.SystemTables.getComi()
RETURN
PROCESS:
    IF Y.DEL.ID NE '' THEN
        EB.DataAccess.FRead(FN.DEL, Y.DEL.ID, REC.DEL, F.DEL, ERR.DEL)
        IF REC.DEL THEN
            Y.CUST.ID = REC.DEL<DE.Config.OHeader.HdrCustomerNo>
            Y.TRANS.REF = REC.DEL<DE.Config.OHeader.HdrTransRef>
        END
        Y.TRANS.REF.LEN = LEN(Y.TRANS.REF)
        Y.TYPE = Y.TRANS.REF[1,2]

        IF Y.TYPE EQ 'TF' AND Y.TRANS.REF.LEN EQ '12' THEN
            EB.DataAccess.FRead(FN.LC, Y.TRANS.REF, REC.LC, F.LC, ERR.LC)
            Y.TRN.REF = REC.LC<LC.Contract.LetterOfCredit.TfLcOldLcNumber>
            IF Y.TRN.REF EQ '' THEN
                Y.TRN.REF = Y.TRANS.REF
            END
        END
    
        IF Y.TYPE EQ 'TF' AND Y.TRANS.REF.LEN NE '12' THEN
            EB.DataAccess.FRead(FN.DR, Y.TRANS.REF, REC.DR, F.DR, ERR.DR)
            Y.TRN.REF = REC.DR<LC.Contract.Drawings.TfDrLocalRef,Y.DR.COL.POS>
            IF Y.TRN.REF EQ '' THEN
                Y.TRN.REF = REC.DR<LC.Contract.Drawings.TfDrLocalRef,Y.TFDR.NO.POS>
            END ELSE
                Y.TRN.REF = Y.TRANS.REF
            END
        END
     
        IF Y.TYPE EQ 'FT' THEN
            EB.DataAccess.FRead(FN.FT, Y.TRANS.REF, REC.FT, F.FT, ERR.FT)
            Y.TRN.REF = REC.FT<FT.Contract.FundsTransfer.CreditTheirRef>
        END
    END
*
*    Y.TEMP = EB.SystemTables.getRNew(DE.Messaging.EbQueriesAnswers.EbQaLocalRef)
*    Y.TEMP<1,Y.TRANS.REF.POS> = Y.TRN.REF
*
    EB.SystemTables.setRNew(DE.Messaging.EbQueriesAnswers.EbQaCustomerNo, Y.CUST.ID)
*    EB.SystemTables.setRNew(DE.Messaging.EbQueriesAnswers.EbQaLocalRef, Y.TEMP)
    EB.SystemTables.setRNew(DE.Messaging.EbQueriesAnswers.EbQaRelReference, Y.TRN.REF)
RETURN

END

