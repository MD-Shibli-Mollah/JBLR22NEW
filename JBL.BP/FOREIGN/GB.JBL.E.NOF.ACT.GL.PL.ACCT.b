SUBROUTINE GB.JBL.E.NOF.ACT.GL.PL.ACCT(Y.RETURN)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING ST.Config
    $USING AC.AccountOpening
    
    FN.AC='F.ACCOUNT'
    F.AC=''

    FN.CAT='F.CATEGORY'
    F.CAT=''

    EB.DataAccess.Opf(FN.AC,F.AC)
    EB.DataAccess.Opf(FN.CAT,F.CAT)

    SEL.CMD.AC="SELECT ":FN.AC:" WITH CATEGORY GE 10000 AND CO.CODE EQ ":EB.SystemTables.getIdCompany():" BY SHORT.TITLE "
    EB.DataAccess.Readlist(SEL.CMD.AC,SEL.LIST.AC,'',NO.OF.REC.AC,ERR.AC)
    
    LOOP
        REMOVE Y.AC.ID FROM SEL.LIST.AC SETTING AC.POS
    WHILE Y.AC.ID:AC.POS
        EB.DataAccess.FRead(FN.AC,Y.AC.ID,REC.AC,F.AC,E.AC)
        Y.RESULT<-1>=Y.AC.ID:"*":REC.AC<AC.AccountOpening.Account.ShortTitle>
    REPEAT

    SEL.CMD.CAT="SELECT ":FN.CAT:" WITH @ID GE 50000 BY DESCRIPTION "
    EB.DataAccess.Readlist(SEL.CMD.CAT,SEL.LIST.CAT,'',NO.OF.REC.CAT,ERR.CAT)

    LOOP
        REMOVE Y.CAT.ID FROM SEL.LIST.CAT SETTING CAT.POS
    WHILE Y.CAT.ID:CAT.POS
        EB.DataAccess.FRead(FN.CAT,Y.CAT.ID,REC.CAT,F.CAT,E.CAT)
        Y.RESULT<-1>="PL":Y.CAT.ID:"*":REC.CAT<ST.Config.Category.EbCatDescription>
    REPEAT

    Y.RETURN=Y.RESULT

RETURN

END
